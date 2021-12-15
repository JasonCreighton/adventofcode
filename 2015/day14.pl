reindeer_desc(vixen, 8, 8, 53).
reindeer_desc(blitzen, 13, 4, 49).
reindeer_desc(rudolph, 20, 7, 132).
reindeer_desc(cupid, 12, 4, 43).
reindeer_desc(donner, 9, 5, 38).
reindeer_desc(dasher, 10, 4, 37).
reindeer_desc(comet, 3, 37, 76).
reindeer_desc(prancer, 9, 12, 97).
reindeer_desc(dancer, 37, 1, 36).

reindeer_time_distance(Reindeer, Time, Distance) :-
    reindeer_desc(Reindeer, Speed, SpeedTime, RestTime),
    Time >= 0,
    CycleTime is SpeedTime + RestTime,
    NumCycles is Time div CycleTime,
    PositionInCycle is Time mod CycleTime,
    DistanceInCycle is Speed * min(SpeedTime, PositionInCycle),
    Distance is (Speed * SpeedTime * NumCycles) + DistanceInCycle.

part1_answer(N) :-
    aggregate_all(max(Dist), reindeer_time_distance(_, 2503, Dist), N).