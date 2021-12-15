reindeer_desc(vixen, 8, 8, 53).
reindeer_desc(blitzen, 13, 4, 49).
reindeer_desc(rudolph, 20, 7, 132).
reindeer_desc(cupid, 12, 4, 43).
reindeer_desc(donner, 9, 5, 38).
reindeer_desc(dasher, 10, 4, 37).
reindeer_desc(comet, 3, 37, 76).
reindeer_desc(prancer, 9, 12, 97).
reindeer_desc(dancer, 37, 1, 36).

% Example data
/*
reindeer_desc(comet, 14, 10, 127).
reindeer_desc(dancer, 16, 11, 162).
*/

reindeer_time_distance(Reindeer, Time, Distance) :-
    reindeer_desc(Reindeer, Speed, SpeedTime, RestTime),
    Time >= 0,
    CycleTime is SpeedTime + RestTime,
    NumCycles is Time div CycleTime,
    PositionInCycle is Time mod CycleTime,
    DistanceInCycle is Speed * min(SpeedTime, PositionInCycle),
    Distance is (Speed * SpeedTime * NumCycles) + DistanceInCycle.

leading_reindeer_time(Reindeer, Time) :-
    aggregate_all(max(D), reindeer_time_distance(_, Time, D), MaxDistance),
    reindeer_time_distance(Reindeer, Time, MaxDistance).

part2_points(Reindeer, Time, 1) :- leading_reindeer_time(Reindeer, Time).
part2_points(Reindeer, Time, 0) :- \+ leading_reindeer_time(Reindeer, Time).

part2_score(Reindeer, Time, Score) :-
    aggregate(sum(Points), T^(between(1, Time, T), part2_points(Reindeer, T, Points)), Score).

part1_answer(N) :-
    aggregate_all(max(Dist), reindeer_time_distance(_, 2503, Dist), N).

part2_answer(N) :-
    aggregate_all(max(Score), part2_score(_, 2503, Score), N).