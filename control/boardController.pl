% The board begins with all of its position empty and
% consists of a pyramid with 11 levels
initial([
    [o, o, o, o, o, o, o, o, o, o, empty, o, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, o, empty, o, empty, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, empty, o, empty, o, empty, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o, o],
    [o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o, o],
    [o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o],
    [o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o],
    [o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o],
    [o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o],
    [empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty]
]).

intermediateBoard([
    [o, o, o, o, o, o, o, o, o, o, empty, o, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, o, empty, o, empty, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, empty, o, empty, o, green, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, empty, o, red, o, empty, o, empty, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, empty, o, empty, o, yellow, o, empty, o, empty, o, o, o, o, o, o],
    [o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, green, o, empty, o, o, o, o, o],
    [o, o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, yellow, o, empty, o, o, o, o],
    [o, o, o, empty, o, green, o, yellow, o, empty, o, empty, o, red, o, empty, o, empty, o, o, o],
    [o, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o],
    [o, empty, o, empty, o, yellow, o, green, o, empty, o, empty, o, yellow, o, empty, o, empty, o, empty, o],
    [empty, o, red, o, empty, o, empty, o, empty, o, red, o, empty, o, empty, o, red, o, empty, o, empty]
]).

finalBoard([
    [o, o, o, o, o, o, o, o, o, o, empty, o, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, o, green, o, empty, o, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, o, red, o, empty, o, green, o, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, o, empty, o, red, o, empty, o, empty, o, o, o, o, o, o, o],
    [o, o, o, o, o, o, empty, o, red, o, empty, o, green, o, empty, o, o, o, o, o, o],
    [o, o, o, o, o, empty, o, empty, o, empty, o, empty, o, green, o, empty, o, o, o, o, o],
    [o, o, o, o, empty, o, green, o, empty, o, empty, o, empty, o, empty, o, empty, o, o, o, o],
    [o, o, o, empty, o, empty, o, empty, o, empty, o, empty, o, red, o, green, o, empty, o, o, o],
    [o, o, empty, o, red, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, empty, o, o],
    [o, green, o, empty, o, yellow, o, green, o, empty, o, red, o, yellow, o, empty, o, empty, o, empty, o],
    [empty, o, red, o, empty, o, empty, o, red, o, red, o, empty, o, green, o, red, o, empty, o, empty]
]).