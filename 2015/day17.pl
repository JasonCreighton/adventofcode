puzzle_input([43, 3, 4, 10, 21, 44, 4, 6, 47, 41, 34, 17, 17, 44, 36, 31, 46, 9, 27, 38]).

ordered_sublist(_, []).
ordered_sublist([X|XS], [Y|YS]) :-
    (X = Y, ordered_sublist(XS, YS))
;   ordered_sublist(XS, [Y|YS]).

part1_answer(N) :-
    puzzle_input(Input),
    aggregate_all(count, (ordered_sublist(Input, Used), sum_list(Used, 150)), N).

part2_answer(N) :-
    puzzle_input(Input),
    aggregate_all(min(NumUsed), (ordered_sublist(Input, Used), sum_list(Used, 150), length(Used, NumUsed)), MinNumUsed),
    aggregate_all(count, (ordered_sublist(Input, Used), length(Used, MinNumUsed), sum_list(Used, 150)), N).
