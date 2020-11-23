% Get Start collumn of a specific row getCollumn(Row, Collumn)
getCollumn(11, 1).
getCollumn(X, Y):-
    X1 is X + 1,
    getCollumn(X1, Y1),
    Y is Y1 + 1.

% Conversion of letter to number
letter('A', L) :- L = 1.
letter('B', L) :- L = 2.
letter('C', L) :- L = 3.
letter('D', L) :- L = 4.
letter('E', L) :- L = 5.
letter('F', L) :- L = 6.
letter('G', L) :- L = 7.
letter('H', L) :- L = 8.
letter('I', L) :- L = 9.
letter('J', L) :- L = 10.
letter('G', L) :- L = 11.