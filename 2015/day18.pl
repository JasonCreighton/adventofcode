:- dynamic initially_alive/2.
:- table alive/4 as incremental.

read_file(File, Str) :-
    setup_call_cleanup(
        open(File, read, In),
        read_string(In, _, Str),
        close(In)).

load_facts :-
    retractall(initially_alive(_, _)),
    read_file("inputs/day18.txt", Str),
    split_string(Str, "\n", "", Lines),
    nth0(X, Lines, Line),
    string_chars(Line, LineChars),
    nth0(Y, LineChars, '#'),
    assert(initially_alive(X, Y)).

corner(0, 0).
corner(0, 99).
corner(99, 0).
corner(99, 99).

alive(ForceCorners, X, Y, 0) :- initially_alive(X, Y); (ForceCorners, corner(X, Y)).
alive(ForceCorners, X, Y, Gen) :-
    Gen > 0,
    X >= 0, X < 100,
    Y >= 0, Y < 100,
    LastGen is Gen - 1,
    neighbors(ForceCorners, X, Y, LastGen, Neighbors),
    (
        (alive(ForceCorners, X, Y, LastGen), Neighbors is 2)
    ;   Neighbors is 3
    ;   (ForceCorners, corner(X, Y))
    ).

num_alive(FC, X, Y, Gen, N) :-
    (
        alive(FC, X, Y, Gen)
    ->  N is 1
    ;   N is 0
    ).

neighbors(FC, X, Y, Gen, N) :-
    XP1 is X + 1, XM1 is X - 1, YP1 is Y + 1, YM1 is Y - 1,
    num_alive(FC, XM1, YM1, Gen, N1),
    num_alive(FC, XM1, Y  , Gen, N2),
    num_alive(FC, XM1, YP1, Gen, N3),
    num_alive(FC, X  , YM1, Gen, N4),
    num_alive(FC, X  , YP1, Gen, N5),
    num_alive(FC, XP1, YM1, Gen, N6),
    num_alive(FC, XP1, Y  , Gen, N7),
    num_alive(FC, XP1, YP1, Gen, N8),
    N is N1 + N2 + N3 + N4 + N5 + N6 + N7 + N8.

part1_answer(N) :-
    aggregate_all(count, (between(0, 99, X), between(0, 99, Y), alive(false, X, Y, 100)), N).

part2_answer(N) :-
    aggregate_all(count, (between(0, 99, X), between(0, 99, Y), alive(true, X, Y, 100)), N).

:- forall(load_facts, true).