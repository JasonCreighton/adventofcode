:- use_module(library(http/json)).

puzzle_input(Json) :-
    setup_call_cleanup(
        open("inputs/day12.json", read, In),
        json_read_dict(In, Json),
        close(In)).

json_number_total(N, N) :- number(N).
json_number_total(Str, 0) :- string(Str).
json_number_total([], 0).
json_number_total([X|XS], N) :-
    json_number_total(X, ThisN),
    json_number_total(XS, RestN),
    N is ThisN + RestN.
json_number_total(Dict, N) :-
    is_dict(Dict),
    dict_pairs(Dict, _, Pairs),
    pairs_values(Pairs, Values),
    json_number_total(Values, N).

part1_answer(N) :-
    puzzle_input(Json),
    json_number_total(Json, N).