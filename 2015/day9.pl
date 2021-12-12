non_symmetric_distance(tristram, alphacentauri, 34).
non_symmetric_distance(tristram, snowdin, 100).
non_symmetric_distance(tristram, tambi, 63).
non_symmetric_distance(tristram, faerun, 108).
non_symmetric_distance(tristram, norrath, 111).
non_symmetric_distance(tristram, straylight, 89).
non_symmetric_distance(tristram, arbre, 132).
non_symmetric_distance(alphacentauri, snowdin, 4).
non_symmetric_distance(alphacentauri, tambi, 79).
non_symmetric_distance(alphacentauri, faerun, 44).
non_symmetric_distance(alphacentauri, norrath, 147).
non_symmetric_distance(alphacentauri, straylight, 133).
non_symmetric_distance(alphacentauri, arbre, 74).
non_symmetric_distance(snowdin, tambi, 105).
non_symmetric_distance(snowdin, faerun, 95).
non_symmetric_distance(snowdin, norrath, 48).
non_symmetric_distance(snowdin, straylight, 88).
non_symmetric_distance(snowdin, arbre, 7).
non_symmetric_distance(tambi, faerun, 68).
non_symmetric_distance(tambi, norrath, 134).
non_symmetric_distance(tambi, straylight, 107).
non_symmetric_distance(tambi, arbre, 40).
non_symmetric_distance(faerun, norrath, 11).
non_symmetric_distance(faerun, straylight, 66).
non_symmetric_distance(faerun, arbre, 144).
non_symmetric_distance(norrath, straylight, 115).
non_symmetric_distance(norrath, arbre, 135).
non_symmetric_distance(straylight, arbre, 127).

route(Locations) :-
    permutation([tristram, alphacentauri, snowdin, tambi, faerun, norrath, straylight, arbre], Locations).

/*
non_symmetric_distance(london, dublin, 464).
non_symmetric_distance(london, belfast, 518).
non_symmetric_distance(dublin, belfast, 141).
route(Locations) :- permutation([london, dublin, belfast], Locations).
*/
distance(A, B, X) :-
    non_symmetric_distance(A, B, X);
    non_symmetric_distance(B, A, X).

route_distance([], 0).
route_distance([_], 0).
route_distance([A,B|RestLocations], Distance) :-
    distance(A, B, ABDistance),
    route_distance([B|RestLocations], BRestDistance),
    Distance is ABDistance + BRestDistance.

part1_answer(N) :-
     aggregate_all(min(Dist), (route(R), route_distance(R, Dist)), N).

part2_answer(N) :-
     aggregate_all(max(Dist), (route(R), route_distance(R, Dist)), N).     