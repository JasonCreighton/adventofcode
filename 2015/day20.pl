puzzle_input(36000000).

part1(NumHouses, ElfNumber, MaxHousesToVisit, PresentsPerHouse) :-
    MaxHousesToVisit is NumHouses div ElfNumber,
    PresentsPerHouse is 10.

part2(_, _, MaxHousesToVisit, PresentsPerHouse) :-
    MaxHousesToVisit is 50,
    PresentsPerHouse is 11.

run_elf_sim(ElfParamPred, NumHouses, PresentCounts) :-
    functor(PresentCounts, presents, NumHouses),
    forall(between(1, NumHouses, H), nb_setarg(H, PresentCounts, 0)),
    forall((
        between(1, NumHouses, I),
        call(ElfParamPred, NumHouses, I, MaxHousesToVisit, PresentsPerHouse),
        MaxJIndex is MaxHousesToVisit - 1,
        between(0, MaxJIndex, J),
        H is I + (J * I),
        H =< NumHouses,
        arg(H, PresentCounts, OldPresentCount),
        NewPresentCount is OldPresentCount + (I * PresentsPerHouse),
        nb_setarg(H, PresentCounts, NewPresentCount)
    ), true).

part1_answer(H) :-
    puzzle_input(Input),
    NumHouses = 1000000,
    run_elf_sim(part1, NumHouses, PresentCounts),
    between(1, NumHouses, H),
    arg(H, PresentCounts, Count),
    Count >= Input.

part2_answer(H) :-
    puzzle_input(Input),
    NumHouses = 1000000,
    run_elf_sim(part2, NumHouses, PresentCounts),
    between(1, NumHouses, H),
    arg(H, PresentCounts, Count),
    Count >= Input.