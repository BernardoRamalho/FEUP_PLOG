:-include('data.pl').
:-use_module(library(clpfd)).
:-use_module(library(lists)).

main:-
    baker([85, 98, 60, 70], [[0, 3, 14, 1], [15, 0, 10, 25], [14, 10, 0, 3], [1, 25, 3, 0]]).
baker(PreferedTime, TravelTime):-
    % Create the array that will hold the ordered route
    length(PreferedTime, NumberOfHouses),
    length(Route, NumberOfHouses),

    % Domain
    domain(Route, 1, NumberOfHouses),

    % Restrictions
    all_distinct(Route),
    append(TravelTime, TravelTimeList),
    getRouteTime(Route, TravelTimeList, Time, NumberOfHouses),
    write(Route),
    write('\n'),
    labeling([minimize(Time)], Route),
    write(Time),
    write('<-->'),
    write(Route).


getRouteTime([PrevHouse, House], TravelTimeList, Time, NumberOfHouses):-
    write(TravelTimeList),
    write('\n'),
    Position #= (PrevHouse - 1) * NumberOfHouses + House,
    element(Position, TravelTimeList, HouseTravelTime),
    Time #= HouseTravelTime.

getRouteTime([PrevHouse, House|Rest], TravelTimeList, Time, NumberOfHouses):- 
    write(TravelTimeList),
    write('\n'),
    Position #= (PrevHouse - 1) * NumberOfHouses + House,
    element(Position, TravelTimeList, HouseTravelTime),
    Time #= HouseTravelTime + NextTime,
    getRouteTime([House|Rest], TravelTimeList, NextTime, NumberOfHouses).