:- use_module(library(lists)).

% Get Start collumn of a specific row getStartColumn(Row, Column)
getStartColumn(11, 1).
getStartColumn(10, 2).
getStartColumn(9, 3).
getStartColumn(8, 4).
getStartColumn(7, 5).
getStartColumn(6, 6).
getStartColumn(5, 7).
getStartColumn(4, 8).
getStartColumn(3, 9).
getStartColumn(2, 10).
getStartColumn(1, 11).

% Get End Column of a specific row getEndColumn(Row, Column)
getEndColumn(11, 21).
getEndColumn(10, 20).
getEndColumn(9, 19).
getEndColumn(8, 18).
getEndColumn(7, 17).
getEndColumn(6, 16).
getEndColumn(5, 15).
getEndColumn(4, 14).
getEndColumn(3, 13).
getEndColumn(2, 12).
getEndColumn(1, 11).

% Conversion of letter to number
letterToNumber('a', L) :- L = 1.
letterToNumber('b', L) :- L = 2.
letterToNumber('c', L) :- L = 3.
letterToNumber('d', L) :- L = 4.
letterToNumber('e', L) :- L = 5.
letterToNumber('f', L) :- L = 6.
letterToNumber('g', L) :- L = 7.
letterToNumber('h', L) :- L = 8.
letterToNumber('i', L) :- L = 9.
letterToNumber('j', L) :- L = 10.
letterToNumber('g', L) :- L = 11.
letterToNumber(1, 1).
letterToNumber(2, 2).
letterToNumber(3, 3).
letterToNumber(4, 4).
letterToNumber(5, 5).
letterToNumber(6, 6).
letterToNumber(7, 7).
letterToNumber(8, 8).
letterToNumber(9, 9).
letterToNumber(10, 10).
letterToNumber(11, 11).

% Upper case to Lower case Conversion of Piece Color

pieceColorLower('Red', 'red').
pieceColorLower('red', 'red').
pieceColorLower('Green', 'green').
pieceColorLower('green', 'green').

% Returns the enemy Color
enemyColor('red', 'green').
enemyColor('green', 'red').

enemyColor('Red', 'Green').
enemyColor('Green', 'Red').

% Gets the element at the position in the list getElementAt(Position, Array, Element)
getElementAt(1, [H|_], H).

getElementAt(Position, [_|T], Element):-
    Position > 0,
    NewPosition is Position - 1,
    getElementAt(NewPosition, T, Element).

% Counts the number os pieces in a row

countAllRowPieces([], 0).
countAllRowPieces([H|T], Count):-
    H = 'Red',
    NewCount is Count + 1,
    countAllRowPieces(T, NewCount).
countAllRowPieces([H|T], Count):-
    H = 'red',
    NewCount is Count + 1,
    countAllRowPieces(T, NewCount).
countAllRowPieces([H|T], Count):-
    H = 'Green',
    NewCount is Count + 1,
    countAllRowPieces(T, NewCount).
countAllRowPieces([H|T], Count):-
    H = 'green',
    NewCount is Count + 1,
    countAllRowPieces(T, NewCount).
countAllRowPieces([H|T], Count):-
    H = 'yellow',
    NewCount is Count + 1,
    countAllRowPieces(T, NewCount).
countAllRowPieces([_|T], Count):-
    countAllRowPieces(T, Count).

% Checks if two lists with length 2 are diferent
listIsDifferent([X|_], [Y|_]):-
    X \= Y.

listIsDifferent([_|Z], [_|T]):-
    Z \= T.

% Check if a list is a list of lists
listIsListOfLists([H|_]):-
    is_list(H).

listIsListOfLists([_|T]):-
    listIsListOfLists(T).

isEmpty([]).

existsInListofLists([H|_], X):-
    select(X, H, _).

existsInListofLists([_|T], X):-
    existsInListofLists(T, X).