:- use_module(library(http/json)).

puzzle_input(Json) :-
    setup_call_cleanup(
        open("inputs/day12.json", read, In),
        json_read_dict(In, Json),
        close(In)).

json_number_total(_, N, N) :- number(N).
json_number_total(_, Str, 0) :- string(Str).
json_number_total(_, [], 0).
json_number_total(IgnoreRed, [X|XS], N) :-
    json_number_total(IgnoreRed, X, ThisN),
    json_number_total(IgnoreRed, XS, RestN),
    N is ThisN + RestN.
json_number_total(IgnoreRed, Dict, N) :-
    is_dict(Dict),
    dict_pairs(Dict, _, Pairs),
    pairs_values(Pairs, Values),
    (
        (IgnoreRed, member("red", Values))
    ->  N = 0
    ;   json_number_total(IgnoreRed, Values, N)
    )
    .

part1_answer(N) :-
    puzzle_input(Json),
    json_number_total(false, Json, N).

part2_answer(N) :-
    puzzle_input(Json),
    json_number_total(true, Json, N).