:-include('data.pl').
:- use_module(library(clpfd)).
:- use_module(library(lists)).
:- use_module(library(random)).

main:-
    baker([20, 70, 120, 130,20,30,20,10,1,5], 
        [
        [0,3,14, 1,30,10,2,5,20,30], 
        [15, 0,10, 25,20,21,30,2,40,10], 
        [14,10,0, 3,40,20,30,1,20,49], 
        [1,25,3, 0,2,3,4,10,40,30],
        [1,10,10,20,0,1, 25, 3,10,20],
        [14,10,20, 3,20,0,30,1,20,49],
        [14,10,19, 3,40,40,0,1,25,9],
        [1,25,3,20,2,3,70,0,40,30],
        [1,35,32,27,21,32,22,0,0,30],
        [1,25,3,20,2,3,70,0,40,0]
        ], [10, 5,15, 20, 15,20,10,2,19,20]),

    baker([20,75,10,13,20,30,20,10,1,50,30,70,2,13,26],
            [
               [0,3,14, 1,30,10,2,5,20,30,20,40,10,2,23], 
               [72,0,10,25,20,21,30,2,40,10,20,40,10,2,50], 
               [18,10,0,3,40,20,30,1,20,49,20,40,10,2,90], 
               [25,25,3,0,2,3,4,10,40,30,20,40,10,2,70],
               [87,10,10,20,0,1,25,3,10,20,20,40,10,2,27],
               [12,10,20,3,20,0,30,1,20,49,20,40,10,2,80],
               [18,10,19,3,40,40,0,1,25,9,20,40,10,2,20],
               [87,25,3,20,2,3,70,0,40,30,20,40,10,2,20],
               [21,35,32,27,21,32,22,76,0,30,20,40,10,2,20],
               [11,25,3,20,2,3,70,15,40,0,20,40,10,2,23],
               [1,25,3,20,2,3,70,40,40,30,0,40,10,2,16],
               [1,25,3,20,2,3,70,20,40,30,20,0,10,2,82],
               [10,25,3,20,2,3,70,30,40,30,60,40,0,2,17],
               [81,25,3,20,2,3,70,20,40,30,20,40,10,0,70],
               [71,25,3,20,2,3,70,50,40,30,30,40,10,2,0]
               
               ], [10,5,15,20,15,20,10,22,19,20,20,10,2,4,56]),
               
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

    reset_timer,
    labeling([minimize(Score)], Route),

    
    print_time,
	fd_statistics,
    displayResults(Route, DeliveryInstants).
    


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
displayResults(Route, DeliveryInstants):-
    write('\n  Route  \n'),
    displayRoute(Route),
    displayHeader,
    displayTableContent(Route, DeliveryInstants).

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



reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T/10)*10)/1000,
	nl, write('Time: '), write(T), write('ms'), nl, nl.