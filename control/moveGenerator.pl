:-include('boardController.pl').
:- use_module(library(lists)).

/*
    generateAllMoves(StartCoords, EndCoords, Board, NWDDiagonalMoves, NEDiagonalMoves, ElineMoves).
    This function generates all moves from the StartCoords. Saves all the ending coords in EndCoords.
    NWDDiagonalMoves, NEDDiagonalMoves, ElineMoves are the number of moves that the piece can do along the
    NorthWest Diagonal, North Eas Diagonal and horizontally, respectively.
*/
generateAllMoves(_, [], _, 0, 0, 0).

generateAllMoves(StartCoords, EndCoords, Board, NWDiagonalMoves, NEDiagonalMoves, ELineMoves):-
    
    % Get Path that starts on the northwest
    getNWMoves(StartCoords, StartCoords, NWCoords, [0|0], Board, NWDiagonalMoves),

    % Get Path that starts on the northeast
    getNEMoves(StartCoords, StartCoords, NECoords, [0|0], Board, NEDiagonalMoves),

    % Get Path that starts on the east
    getEMoves(StartCoords, StartCoords, ECoords, [0|0], Board, ELineMoves),

    % Get Path that starts on the west 
    getWMoves(StartCoords, StartCoords, WCoords, [0|0], Board, ELineMoves),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, StartCoords, SECoords, [0|0], Board, NWDiagonalMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, StartCoords, SWCoords, [0|0], Board, NEDiagonalMoves),

    formatAllCoords([NWCoords, NECoords, ECoords, WCoords, SECoords, SWCoords], EndCoords).
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

% This is called when it encounters an obstacle. So it tries to go in every direction
generateNWMoves(StartCoords, CurrentCoords, [NECoords, ECoords, WCoords, SECoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves).

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

% This is called when it encounters an obstacle. So it tries to go in every direction
generateNEMoves(StartCoords, CurrentCoords, [NWCoords, ECoords, WCoords, SECoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves).

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

% This is called when it encounters an obstacle. So it tries to go in every direction
generateEMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, WCoords, SECoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves).

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

% This is called when it encounters an obstacle. So it tries to go in every direction
generateWMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, ECoords, SECoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves).


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

% This is called when it encounters an obstacle. So it tries to go in every direction
generateSEMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, ECoords, WCoords, SWCoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSWMoves(StartCoords, CurrentCoords, SWCoords, PreviousCoords, Board, NrMoves).

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

% This is called when it encounters an obstacle. So it tries to go in every direction
generateSWMoves(StartCoords, CurrentCoords, [NWCoords, NECoords, ECoords, WCoords, SECoords], PreviousCoords, Board, NrMoves):-
    % Get Path that starts on the northeast
    getNWMoves(StartCoords, CurrentCoords, NWCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the east
    getNEMoves(StartCoords, CurrentCoords, NECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the west 
    getEMoves(StartCoords, CurrentCoords, ECoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southeast
    getWMoves(StartCoords, CurrentCoords, WCoords, PreviousCoords, Board, NrMoves),

    % Get Path that starts on the southwest
    getSEMoves(StartCoords, CurrentCoords, SECoords, PreviousCoords, Board, NrMoves).

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

    formatAllCoords(OldCoords, NewCoords).
    Old Coords is a List that can have lists that can have other lists. So we need to make it so it is only one list.
    It also removes all duplicates from the Old Coords

*/

formatAllCoords(OldCoords, NewCoords):-
    % Makes sure everything is a List so we can use append function without worrying
    formateCoords(OldCoords, FormattedCoords),

    % Appends all the lists into a single one (No lists of lists)
    appendAllLists(FormattedCoords, Coords, _),

    % Removes all duplicates
    remove_dups(Coords, NoDupsCoords),

    % Removes a [] if it exits since it wont be neeeded
    delete(NoDupsCoords, [], NewCoords).

/*
    
    appendAllLists(Old Coords, NewCoords, PlaceHolder).
    Appends all the lists from Old Coords into a single one in New Coords
    PlaceHolder serves as an auxiliary list to move around the lists that are inside lists.

*/

appendAllLists([], NewCoords, NewCoords).

appendAllLists([[H|Z] | T], NewCoords, PlaceHolder):-
    % Check if the first element is a list of lists
    listIsListOfLists([H|Z]),

    % Checks if the first element inside the first element is also a list
    listIsListOfLists(H),

    % Appends all the lists from the first element into one
    appendAllLists([H|Z], NormalH, []),

    % Appends the list that we got from the first element with the placeHolder
    append([PlaceHolder,NormalH], NewNewCoords),

    % Calls the function to the remaining part of the Old Coords
    appendAllLists(T, NewCoords, NewNewCoords).

% This function is called when the first element is a list of lists with no more Lists of Lists inside it
appendAllLists([H | T], NewCoords, PlaceHolder):-
    /*
    Checks if H is a List, if it is we know that it doesnt have any more lists of lists inside of it.
    This is because it would run the predicate above and not this.
    */
    listIsListOfLists(H),
    
    % Appends all the elements of H into one list
    append(H, Appended),

    % Appends the list with all the H element into PlaceHolder
    append([PlaceHolder,Appended], NewNewCoords),

    % Calls the function to the remaining part of the Old Coords
    appendAllLists(T, NewCoords, NewNewCoords).

% This is called when the first element is a simple List
appendAllLists([H|T], NewCoords, PlaceHolder):-
    % Appends the first element with PlaceHolder
    append([PlaceHolder, H], NewNewCoords),

    % Calls the function to the remaining part of the Old Coords
    appendAllLists(T, NewCoords, NewNewCoords).

/*
    
    formateCoords(OldCoords, NewCoords).
    This function makes sure everything inside the OldCoords is a list. I.e., all number are inside lists.
    This is to make sure we can use append, without any problems, in the functions above.

*/

formateCoords([],[]).

formateCoords([H|T], [X|Y]):-
    is_list(H),
    % Makes sure everything inside the list is a list
    formateList(H, X),

    % Format the rest of the list
    formateCoords(T, Y).

% This is called when H is a single number, so just put it inside a list and formate the rest
formateCoords([H|T], [ [H]|Y]):-
    formateCoords(T, Y).

/*
    
    formateList(OldList, NewList).
    Makes sure everythin inside OldList is a List and saves it into NewList

*/
formateList([], [], _).

formateList([H | T], [H | X]):-
    % Check if the first element is a single element or a list of lists. If it is, it doesnt need any alteration.
    listIsListOfLists([H|T]),
    formateList(T, X).

% This is called when H is a single number, puts it inside a list.
formateList([H | T], [ [H] | X ]):-
    formateList(T, X).
