:-include('boardController.pl').
:- use_module(library(lists)).

display:-
    initial(Board),
    printBoard(Board).

test(Moves, Start, X):-
    initial(Board),
    getAllMoves(Start, X, Board, Moves, Moves, Moves)
    .

getAllMoves(StartCoords, EndCoords, Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves):-
    generateAllMoves(StartCoords, EndCoords, [0|0], Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves).

generateAllMoves(StartCoords, [NWCoords, NECoords, ECoords, WCoords, SECoords, SWCoords], PreviousCoords, Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves):-
    
    % Get Path that starts on the northwest
    getNWMoves(StartCoords, StartCoords, NWCoords, PreviousCoords, Board, NWDiagonalMoves),
    write('NW\n'),
    write(NWCoords),
    write('\n'),
    % Get Path that starts on the northeast
    getNEMoves(StartCoords, StartCoords, NECoords, PreviousCoords, Board, NEDiagonalMoves),
    write('NE\n'),
    write(NECoords),
    write('\n'),
    % Get Path that starts on the east
    getEMoves(StartCoords, StartCoords, ECoords, PreviousCoords, Board, ELineMoves),
    write('E\n'),
    write(ECoords),
    write('\n'),
    % Get Path that starts on the west 
    getWMoves(StartCoords, StartCoords, WCoords, PreviousCoords, Board, ELineMoves),
    write('W\n'),
    write(WCoords),
    write('\n'),
    % Get Path that starts on the southeast
    getSEMoves(StartCoords, StartCoords, SECoords, PreviousCoords, Board, NWDiagonalMoves),
    write('SE\n'),
    write(SECoords),
    write('\n'),
    % Get Path that starts on the southwest
    getSWMoves(StartCoords, StartCoords, SWCoords, PreviousCoords, Board, NEDiagonalMoves),
    write('SW\n'),
    write(SWCoords),
    write('\n').
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
generateNWMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),
    formateCoords(NECoords, EndCoords),

    % Get Path that starts on the east
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),
    formateCoords(ECoords, EndCoords),

    % Get Path that starts on the west 
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),
    formateCoords(WCoords, EndCoords),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),
    formateCoords(SECoords, EndCoords),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves),
    formateCoords(SWCoords, EndCoords).

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

% Get the next move in the NorthEast direction
generateNEMoves(StartCoords, CurrentCoords, EndCoords, PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),
    formateCoords(NWCoords, EndCoords),

    % Get Path that starts on the east
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),
    formateCoords(ECoords, EndCoords),

    % Get Path that starts on the west 
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),
    formateCoords(WCoords, EndCoords),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),
    formateCoords(SECoords, EndCoords),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves),
    formateCoords(SWCoords, EndCoords).

generateNEMoves(_, _, [], _, _, _).

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

generateEMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, WCoords, SECoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),
    formateCoords(NWCoords, EndCoords),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),
    formateCoords(NECoords, EndCoords),

    % Get Path that starts on the west 
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),
    formateCoords(WCoords, EndCoords),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),
    formateCoords(SECoords, EndCoords),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves),
    formateCoords(SWCoords, EndCoords).

generateEMoves(_, _, [], _, _, _).


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

generateWMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, ECoords, SECoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),
    formateCoords(NWCoords, EndCoords),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),
    formateCoords(NECoords, EndCoords),

    % Get Path that starts on the west 
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),
    formateCoords(ECoords, EndCoords),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),
    formateCoords(SECoords, EndCoords),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves),
    formateCoords(SWCoords, EndCoords).


generateWMoves(_, _, [], _, _, _).


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
generateSEMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, ECoords, WCoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),
    formateCoords(NWCoords, EndCoords),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),
    formateCoords(NECoords, EndCoords),

    % Get Path that starts on the west 
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),
    formateCoords(ECoords, EndCoords),

    % Get Path that starts on the southeast
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),
    formateCoords(WCoords, EndCoords),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves),
    formateCoords(SWCoords, EndCoords).

generateSEMoves(_, _, [], _, _, _).

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


generateSWMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, ECoords, WCoords, SECoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),
    formateCoords(NWCoords, EndCoords),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),
    formateCoords(NECoords, EndCoords),

    % Get Path that starts on the west 
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),
    formateCoords(ECoords, EndCoords),

    % Get Path that starts on the southeast
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),
    formateCoords(WCoords, EndCoords),

    % Get Path that starts on the southwest
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),
    formateCoords(SECoords, EndCoords).

generateSWMoves(_, _, [], _, _, _).

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

/*

    Checks if a list is a list of lists and appends it

*/

formateShit(OldCoords, NewCoords):-
    formateCoords(OldCoords, FormattedCoords),
    appendAllLists(FormattedCoords, NewCoords, _, 1).

appendAllLists([H|T], NewCoords, PlaceHolder, 1):-
    append([H], PlaceHolder),
    appendAllLists(T, NewCoords, PlaceHolder, 2).

appendAllLists([], NewCoords, NewCoords, 2).

appendAllLists([H | T], NewCoords, PlaceHolder, 2):-
    listIsListOfLists(H),
    append(H, Appended),
    append([PlaceHolder,Appended], NewNewCoords),
    appendAllLists(T, NewCoords, NewNewCoords, 2).

appendAllLists([H|T], NewCoords, PlaceHolder, 2):-
    append([PlaceHolder, H], NewNewCoords),
    appendAllLists(T, NewCoords, NewNewCoords, 2).


formateCoords([],[]).
formateCoords([H|T], [X|Y]):-
    is_list(H),
    formateListOfLists(H, X, 1),
    formateCoords(T, Y).
formateCoords([H|T], [X|Y]):-
    formateListOfLists(H, X, 2),
    formateCoords(T, Y).

formateListOfLists([], [], _).

formateListOfLists([H | T], [H | X], 1):-
    listIsListOfLists([H|T]),
    formateListOfLists(T, X).

formateListOfLists([H | T], [ [H] | X ], 1):-
    formateListOfLists(T, X).

formateListOfLists(H, [H], 2).