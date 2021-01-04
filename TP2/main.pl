:-include('data.pl').
:-use_module(library(clpfd)).
:-use_module(library(lists)).

main:-
    baker([20, 70, 120, 130], [[0, 3, 14, 1], [15, 0, 10, 25], [14, 10, 0, 3], [1, 25, 3, 0]], [10, 5, 20, 15]).

baker(PreferedTime, HouseTravelTime, BakeryTravelTime):-
    % Get the number of houses to visit
    length(PreferedTime, NumberOfHouses),

    
    % Route and DeliveryInstants must have an entry for each house
    length(Route, NumberOfHouses),
    length(DeliveryInstants, NumberOfHouses),

    % Domain
    domain(Route, 1, NumberOfHouses),
    domain(DeliveryInstants, 1, 100000),

    % Restrictions

    % Each house must be passed only once and the baker can't be in two houses at the same time
    all_distinct(Route),
    all_distinct(DeliveryInstants),

    % The first instant must be the prefered time from the bakery to the first house
    element(1, Route, FirstHouseID),
    element(FirstHouseID, PreferedTime, BakeryToHouseTime),
    element(1, DeliveryInstants, BakeryToHouseTime),

    % Each house delivery instant must be equal to the previous house instant plus the travel time between houses
    append(HouseTravelTime, TravelTimeList),
    getRouteTime(Route, TravelTimeList, PreferedTime, DeliveryInstants, Delay, NumberOfHouses),

    % The full time is equal ot the time spend passsing through all the houses plus the time from the last house to the bakery
    element(NumberOfHouses, Route, LastHouseID),
    element(LastHouseID, BakeryTravelTime, HouseToBakeryTime),
    element(NumberOfHouses, DeliveryInstants, LastInstant),
    Time #= LastInstant + HouseToBakeryTime,

    evaluateRoute(Time, Delay, Score),

    labeling([minimize(Score)], Route),
    displayResults(Route, DeliveryInstants, Time, Delay).


getRouteTime([PrevHouse, House], TravelTimeList, PreferedTime, [PrevHouseTime, HouseTime], Delay, NumberOfHouses):-
    Position #= (PrevHouse - 1) * NumberOfHouses + House,
    element(Position, TravelTimeList, HouseTravelTime),
    TimeAtHouse #= (PrevHouseTime + 5) + HouseTravelTime,

    % Get Delay
    element(House, PreferedTime, DeliveryTime),
    isLate(TimeAtHouse, DeliveryTime, HouseTime, Delay).

getRouteTime([PrevHouse, House|Rest], TravelTimeList, PreferedTime, [PrevHouseTime, HouseTime | RestTime], Delay, NumberOfHouses):- 
    % Get travel Time
    Position #= (PrevHouse - 1) * NumberOfHouses + House,
    element(Position, TravelTimeList, HouseTravelTime),
    TimeAtHouse #= HouseTravelTime + (PrevHouseTime + 5),

    % Get Delay
    element(House, PreferedTime, DeliveryTime),
    isLate(TimeAtHouse, DeliveryTime, HouseTime, UnsignedDelay),

    Delay #= UnsignedDelay + NewDelay,

    getRouteTime([House|Rest], TravelTimeList, PreferedTime, [HouseTime | RestTime], NewDelay, NumberOfHouses).

isLate(GetToHouseTime, SupposedTime, GetToHouseTime, 0):-
    GetToHouseTime #=< SupposedTime - 10,
    GetToHouseTime #>= SupposedTime - 40.

isLate(GetToHouseTime, SupposedTime, GetToHouseTime, Delay):-
    GetToHouseTime #> SupposedTime - 10,
    Delay #= GetToHouseTime - SupposedTime.

isLate(_, SupposedTime, TimeAtHouse, 0):-
    TimeAtHouse #= SupposedTime - 10.

evaluateRoute(Time, Delay, Score):-
    Score #= Time + Delay.

convertDelay(SignedDelay, UnsignedDelay):-
    SignedDelay #< 0,
    UnsignedDelay #= SignedDelay * -1.

convertDelay(SignedDelay, SignedDelay).

displayResults([], []).
displayResults(Route, DeliveryInstants, Time, Delay):-
    write('\n  Route  \n'),
    displayRoute(Route),
    displayHeader,
    displayTableContent(Route, DeliveryInstants),
    nl,
    write('The trip was made in '),
    write(Time),
    write(' instants with a delay of '),
    write(Delay),
    write(' instants.\n').

displayHeader:-
    nl,
    write('House  Instants'),
    nl.

displayRoute([House|[]]):-
    write(House),
    nl.
displayRoute([House|Rest]):- 
    write(House),
    write(' ---> '),
    displayRoute(Rest).

displayTableContent([],[]).
displayTableContent([House|Rest], [Time|RestTime]):-
    write('   '),
    write(House),
    write(' --> '),
    write(Time),
    nl,
    displayTableContent(Rest, RestTime).