puzzle_input(CharList) :- number_chars(1113122113, CharList).

say(X-N, Said) :-
    number_chars(N, NAsChars),
    append(NAsChars, [X], Said).

look_and_say([], []).
look_and_say(Look, Said) :-
    clumped(Look, RunLengths),
    maplist(say, RunLengths, SaidRunLengths),
    flatten(SaidRunLengths, Said).

look_and_say_n(X, X, 0).
look_and_say_n(Look, Said, N) :-
    N > 0,
    N1 is N - 1,
    look_and_say(Look, Tmp),
    look_and_say_n(Tmp, Said, N1).

part1_answer(N) :-
    puzzle_input(Look),
    look_and_say_n(Look, Said, 40),
    length(Said, N).

part2_answer(N) :-
    puzzle_input(Look),
    look_and_say_n(Look, Said, 50),
    length(Said, N).