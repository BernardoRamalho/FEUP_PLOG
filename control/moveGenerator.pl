:-include('boardController.pl').

test(Moves, [C|R], X):-
    initial(Board),
    NWC is C - 1,
    NWR is R -1,
    generateNWMoves([C|R], [NWC|NWR], X, [0|0], Board, Moves).


generateAllMoves(StartCoords, EndCoords, Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves):-
    generateNWMoves(StartCoords, [0|0], NWCoords, [0| 0], Board, NWDiagonalMoves),
    generateNEMoves(StartCoords, [0|0], NECoords, [0| 0], Board, NEDiagonalMoves),
    generateEMoves(StartCoords, [0|0], ECoords, [0| 0], Board, ELineMoves),
    generateWMoves(StartCoords, [0|0], WCoords, [0| 0], Board, ELineMoves),
    generateSEMoves(StartCoords, [0|0], SECoords, [0| 0], Board, NWDiagonalMoves),
    generateSWMoves(StartCoords, [0|0], SWCoords, [0| 0], Board, NEDiagonalMoves).

/*
    generateNWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 1):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).


generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow - 1,
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

/*
    Check if it is a valid position
*/
isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords):-
    % Position must be diferent then start position
    listIsDifferent([CurrentColumn|CurrentRow], StartCoords),

    % Position must be diferent then previous position
    listIsDifferent([CurrentColumn|CurrentRow], PreviousCoords),

    % Position must be empty
    checkValidPosition([CurrentColumn|CurrentRow], Board, 'empty').