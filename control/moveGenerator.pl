:-include('boardController.pl').

display:-
    initial(Board),
    printBoard(Board).

test(Moves, [C|R]):-
    initial(Board),
    generateAllMoves([C|R], _, Board, Moves, Moves, Moves).


generateAllMoves([StartColumn|StartRow], EndCoords, Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves):-
    
    % Get Path that starts on the northwest
    NWC is StartColumn - 1,   
    NWR is StartRow - 1,
    generateNWMoves([StartColumn|StartRow], [NWC|NWR], NWCoords, [0| 0], Board, NWDiagonalMoves),

    % Get Path that starts on the northeast
    NEC is StartColumn + 1,   
    NER is StartRow - 1,
    generateNEMoves([StartColumn|StartRow], [NEC|NER], NECoords, [0| 0], Board, NEDiagonalMoves),

    % Get Path that starts on the east
    EC is StartColumn + 2,   
    generateEMoves([StartColumn|StartRow], [EC|StartRow], ECoords, [0| 0], Board, ELineMoves),

    % Get Path that starts on the west
    WC is StartColumn - 2,   
    generateWMoves([StartColumn|StartRow], [WC|StartRow], WCoords, [0| 0], Board, ELineMoves),

    % Get Path that starts on the southeast
    SEC is StartColumn + 1,   
    SER is StartRow + 1,
    generateSEMoves([StartColumn|StartRow], [SEC|SER], SECoords, [0| 0], Board, NWDiagonalMoves),

    % Get Path that starts on the southwest
    SWC is StartColumn - 1,   
    SWR is StartRow + 1,
    generateSWMoves([StartColumn|StartRow], [SWC|SWR], SWCoords, [0| 0], Board, NEDiagonalMoves).
    
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
    generateNEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 1):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).


generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow - 1,
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

/*
    generateEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateEMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 1):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).


generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewColumn is CurrentColumn + 2,
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

/*
    generateWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateWMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 1):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).


generateWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewColumn is CurrentColumn - 2,
    NewNrMoves is NrMoves - 1,
    generateWMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).


/*
    generateSEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateSEMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 1):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).


generateSEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    NewNrMoves is NrMoves - 1,
    generateSEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

/*
    generateSWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateSWMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 1):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).


generateSWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow + 1,
    NewNrMoves is NrMoves - 1,
    generateSWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

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