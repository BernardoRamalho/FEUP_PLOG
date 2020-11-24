:-include('boardController.pl').

display:-
    initial(Board),
    printBoard(Board).

test(Moves, [C|R], X):-
    initial(Board),
    getEMoves([C|R], [C|R], X,  [0| 0], Board, Moves).


generateAllMoves([StartColumn|StartRow], EndCoords, Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves):-
    
    % Get Path that starts on the northwest
    getNWMoves([StartColumn|StartRow], [StartColumn|StartRow], NWCoords, [0| 0], Board, NWDiagonalMoves),

    % Get Path that starts on the northeast
    write(NWCoords),
    getNEMoves([StartColumn|StartRow], [StartColumn|StartRow], NECoords, [0| 0], Board, NEDiagonalMoves),
    write(NECoords),

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


                        NORTH WEST MOVES


*/

/*
    getNWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getNWMoves(_, _, [], _, _, _).

/*
    generateNWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).

% Get the next move in the NorthWest direction
generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthEast direction
generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the West direction
generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the East direction
generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthWest direction
generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthEast direction
generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

/*


                        NORTH EAST MOVES


*/

/*
    getNEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getNEMoves(_, _, [], _, _, _).

/*
    generateNEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).

% Get the next move in the NorthEast direction
generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthWest direction
generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the West direction
generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the East direction
generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthWest direction
generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 2,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthEast direction
generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

/*


                        EAST MOVES


*/

/*
    getEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getEMoves(_, _, [], _, _, _).
/*
    generateEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateEMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).

% Get the next move in the East direction
generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthEast direction
generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthWest direction
generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the West direction
generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthWest direction
generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthEast direction
generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).


/*


                        WEST MOVES


*/

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


                        SOUTH EAST MOVES


*/

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


                        SOUTH WEST MOVES


*/

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