:-include('boardController.pl').

display:-
    initial(Board),
    printBoard(Board).

test(Moves, Start, X):-
    initial(Board),
    getAllMoves(Start, X, Board, Moves, Moves, Moves).

getAllMoves(StartCoords, EndCoords, Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves):-
    generateAllMoves(StartCoords, EndCoords, [0|0], Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves).

generateAllMoves(StartCoords, [NWCoords, NECoords, ECoords, WCoords, SECoords, SWCoords], PreviousCoords, Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves):-
    
    % Get Path that starts on the northwest
    getNWMoves(StartCoords, StartCoords, NWCoords, PreviousCoords, Board, NWDiagonalMoves),

    % Get Path that starts on the northeast
    getNEMoves(StartCoords, StartCoords, NECoords, PreviousCoords, Board, NEDiagonalMoves),

    % Get Path that starts on the east
    getEMoves(StartCoords, StartCoords, ECoords, PreviousCoords, Board, ELineMoves),

    % Get Path that starts on the west 
    getWMoves(StartCoords, StartCoords, WCoords, PreviousCoords, Board, ELineMoves),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, StartCoords, SECoords, PreviousCoords, Board, NWDiagonalMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, StartCoords, SWCoords, PreviousCoords, Board, NEDiagonalMoves).

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
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

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
    generateEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthWest direction
generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthEast direction
generateNWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

generateNWMoves(_, _, [], _, _, _).

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
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the West direction
generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateWMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the East direction
generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthWest direction
generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 2,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthEast direction
generateNEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

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
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthWest direction
generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the West direction
generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateWMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthWest direction
generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthEast direction
generateEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).


/*


                        WEST MOVES


*/

/*
    getWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateWMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getWMoves(_, _, [], _, _, _).

/*
    generateWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateWMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).

% Get the next move in the West direction
generateWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateWMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the East direction
generateWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthEast direction
generateWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthWest direction
generateWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthWest direction
generateWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthEast direction
generateWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).


/*


                        SOUTH EAST MOVES


*/

/*
    getSEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getSEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getSEMoves(_, _, [], _, _, _).

/*
    generateSEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateSEMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).

% Get the next move in the SouthEast direction
generateSEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the West direction
generateSEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateWMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the East direction
generateSEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthEast direction
generateSEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthWest direction
generateSEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the SouthWest direction
generateSEMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

/*


                        SOUTH WEST MOVES


*/

/*
    getSWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

getSWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

getSWMoves(_, _, [], _, _, _).

/*
    generateSWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves).
*/

generateSWMoves(StartCoords, [CurrentColumn|CurrentRow], [CurrentColumn|CurrentRow], PreviousCoords, Board, 0):-
        isValidPosition([CurrentColumn|CurrentRow], Board, StartCoords, PreviousCoords).


% Get the next move in the SouthWest direction
generateSWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSWMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).


% Get the next move in the SouthEast direction
generateSWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow + 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateSEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the West direction
generateSWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateWMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the East direction
generateSWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 2,
    isValidPosition([NewColumn|CurrentRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateEMoves(StartCoords, [NewColumn|CurrentRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthEast direction
generateSWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn + 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
    NewNrMoves is NrMoves - 1,
    generateNEMoves(StartCoords, [NewColumn|NewRow], EndCoords, [CurrentColumn|CurrentRow], Board, NewNrMoves).

% Get the next move in the NorthWest direction
generateSWMoves(StartCoords, [CurrentColumn|CurrentRow], EndCoords, PreviousCoords, Board, NrMoves):-
    NewColumn is CurrentColumn - 1,
    NewRow is CurrentRow - 1,
    isValidPosition([NewColumn|NewRow], Board, StartCoords, PreviousCoords),
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