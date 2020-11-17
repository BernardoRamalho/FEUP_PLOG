% Get Start collumn of a specific row getCollumn(Row, Collumn)
getCollumn(11, 1).
getCollumn(X, Y):-
    X1 is X + 1,
    getCollumn(X1, Y1),
    Y is Y1 + 1.